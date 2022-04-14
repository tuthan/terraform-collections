resource "google_service_account" "service_account" {
  account_id   = "log-${var.gcp_project}"
  display_name = "Service Account Log ${var.gcp_project}"
}

resource "google_project_iam_binding" "pub_binding" {
  project = "${var.gcp_project}"
  role = "roles/pubsub.publisher"  
  members  = [
   "serviceAccount:${google_service_account.service_account.account_id}@${var.gcp_project}.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "sub_binding" {
  project = "${var.gcp_project}"  
  role = "roles/pubsub.subscriber"
  members  = [
      "serviceAccount:${google_service_account.service_account.account_id}@${var.gcp_project}.iam.gserviceaccount.com"
  ]
}

resource "google_service_account_key" "sa_key" {  
  service_account_id = "${google_service_account.service_account.account_id}"
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "local_file" "key" {
  count = var.export_key ? 1 : 0 
  filename = "/tmp/key_${var.gcp_project}.json"
  file_permission = "0640"
  content  = "${base64decode(google_service_account_key.sa_key.private_key)}"
}

resource "google_pubsub_topic" "log-topic" {
  name = "log-topic-${var.gcp_project}"
}

resource "google_pubsub_topic_iam_binding" "topic_binding" {
  project = "${var.gcp_project}"  
  topic = google_pubsub_topic.log-topic.name
  role = "roles/pubsub.publisher"
  members = [
    "serviceAccount:p560721780863-199120@gcp-sa-logging.iam.gserviceaccount.com"
  ]
}

resource "google_pubsub_subscription" "siem-subscription" {
  name  = "siem-sub-${var.gcp_project}"
  topic = google_pubsub_topic.log-topic.name
    
  message_retention_duration = "86400s"
  retain_acked_messages      = false

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "604800s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering    = false
}

module "audit-log" {
    source = "../audit-log"    
    gcp_project = var.gcp_project
    dest_log_gcp_project = var.gcp_project
}