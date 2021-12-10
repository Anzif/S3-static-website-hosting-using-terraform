variable "domain_name" {
  type = string
  default = "Set required bucket name here"  #delete this line for realtime name assignment while running.
}

variable "mime_types" {
  default = {
    htm   = "text/html"
    html  = "text/html"
    css   = "text/css"
    jpg   = "image/jpg"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    txt  = "text/plain"
  }
}
