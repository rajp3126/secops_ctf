############################################################################################
# Copyright 2019 Palo Alto Networks.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
############################################################################################


############################################################################################
# CREATE BUCKET, CREATE DIRECTORIES & UPLOAD VM-SERIES BOOTSTRAP FILES
############################################################################################

resource "google_storage_bucket" "bootstrap" {
  name          = "bootstrap-bucket-${var.bootstrap_project}"
  location      = var.bootstrap_region
  storage_class = "REGIONAL"
  force_destroy = true
}

resource "google_storage_bucket_object" "bootstrap_dirs" {
  for_each = toset(var.bootstrap_directories)

  name   = each.value
  source = "/dev/null"
  bucket = google_storage_bucket.bootstrap.name
}

resource "google_storage_bucket_object" "bootstrap_files" {
  for_each = fileset("${path.module}/files", "**")

  name   = each.value
  source = "${path.module}/files/${each.value}"
  bucket = google_storage_bucket.bootstrap.name
}
