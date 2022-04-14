resource "google_logging_project_sink" "siem-sink" {
  name = "pubsub-siem-sink-${var.gcp_project}"

  # Export log to pubsub
  destination = "pubsub.googleapis.com/projects/${var.dest_log_gcp_project}/topics/log-topic-${var.dest_log_gcp_project}"
  
  # Require a uniqe writer
  unique_writer_identity = true
}

resource "google_project_iam_binding" "log-writer-pub-sub" {
  project = "${var.gcp_project}"
  role = "roles/pubsub.editor"

  members = [
    google_logging_project_sink.siem-sink.writer_identity,
  ]
}
#Need get the non-managed log writer service account to add to main-project/audit-log.tf  
output "log_service_account_out" {
  value = "Please add this service account to main-project/audit-log.tf if haven't done: ${google_logging_project_sink.siem-sink.writer_identity}"
}
