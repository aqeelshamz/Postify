import 'package:flutter/material.dart';

Map<int, Map<String, String>> statusCodeData = {
  100: {
    "title": "Continue",
    "description":
        "The server has received the request headers, and the client should proceed to send the request body"
  },
  101: {
    "title": "Switching Protocols",
    "description": "The requester has asked the server to switch protocols"
  },
  103: {
    "title": "Checkpoint",
    "description":
        "Used in the resumable requests proposal to resume aborted PUT or POST requests"
  },
  200: {
    "title": "OK",
    "description":
        "The request is OK (this is the standard response for successful HTTP requests)"
  },
  201: {
    "title": "Created",
    "description":
        "The request has been fulfilled, and a new resource is created"
  },
  202: {
    "title": "Accepted",
    "description":
        "The request has been accepted for processing, but the processing has not been completed"
  },
  203: {
    "title": "Non-Authoritative Information",
    "description":
        "The request has been successfully processed, but is returning information that may be from another source"
  },
  204: {
    "title": "No Content",
    "description":
        "The request has been successfully processed, but is not returning any content"
  },
  205: {
    "title": "Reset Content",
    "description":
        "The request has been successfully processed, but is not returning any content, and requires that the requester reset the document view"
  },
  206: {
    "title": "Partial Content",
    "description":
        "The server is delivering only part of the resource due to a range header sent by the client"
  },
  300: {
    "title": "Multiple Choice",
    "description":
        "	A link list. The user can select a link and go to that location. Maximum five addresses  "
  },
  301: {
    "title": "Moved Permenantly",
    "description": "The requested page has moved to a new URL "
  },
  302: {
    "title": "Found",
    "description": "The requested page has moved temporarily to a new URL "
  },
  303: {
    "title": "See Other",
    "description": "	The requested page can be found under a different URL"
  },
  304: {
    "title": "Not Modified",
    "description":
        "Indicates the requested page has not been modified since last requested"
  },
  305: {
    "title": "Use Proxy",
    "description":
        "Defined in a previous version of the HTTP specification to indicate that a requested response must be accessed by a proxy."
  },
  307: {
    "title": "Temporary Redirect",
    "description": "	The requested page has moved temporarily to a new URL"
  },
  308: {
    "title": "Resume Incomplete",
    "description":
        "Used in the resumable requests proposal to resume aborted PUT or POST requests"
  },
  400: {
    "title": "Bad Request",
    "description": "	The request cannot be fulfilled due to bad syntax"
  },
  401: {
    "title": "Unauthorized",
    "description":
        "	The request was a legal request, but the server is refusing to respond to it. For use when authentication is possible but has failed or not yet been provided"
  },
  402: {"title": "Payment Required", "description": ""},
  403: {"title": "Forbiddebn", "description": ""},
  404: {"title": "Not Found", "description": ""},
  405: {"title": "Method Not Allowed", "description": ""},
  406: {"title": "Not Acceptable", "description": ""},
  407: {"title": "Proxy Authentication Failed", "description": ""},
  408: {"title": "Request Tiemout", "description": ""},
  409: {"title": "Conflict", "description": ""},
  410: {"title": "Gone", "description": ""},
  411: {"title": "Length Required", "description": ""},
  412: {"title": "Precondition Failed", "description": ""},
  413: {"title": "Request Entity Too Large", "description": ""},
  414: {"title": "Request-URI Too Long", "description": ""},
  415: {"title": "Unsupported Media Type", "description": ""},
  416: {"title": "Requested Range Not Satisfiable", "description": ""},
  417: {"title": "Expectation Failed", "description": ""},
  500: {"title": "Internal Server Error", "description": ""},
  501: {"title": "Not Implemented", "description": ""},
  502: {"title": "Bad Gateway", "description": ""},
  503: {"title": "Service Unavailable", "description": ""},
  504: {"title": "Gateway Timeout", "description": ""},
  505: {"title": "HTTP Version Not Supported", "description": ""},
  511: {"title": "Network Authentication Required", "description": ""},
};

String getStatusTitle(int statusCode){
  if(statusCodeData.keys.contains(statusCode)){
    return statusCodeData[statusCode]!["title"].toString();
  }
  else{
    return "";
  }
}

Color getStatusColor(int statusCode) {
  Color statusColor = Colors.transparent;
  String firstDigit = statusCode.toString()[0];

  switch (firstDigit) {
    case "1":
      statusColor = Colors.blue;
      break;
    case "2":
      statusColor = Colors.greenAccent[700]!;
      break;
    case "3":
      statusColor = Colors.orange;
      break;
    case "4":
      statusColor = Colors.red;
      break;
    case "5":
      statusColor = Colors.pink[900]!;
      break;
    default:
      statusColor = Colors.black;
      break;
  }

  return statusColor;
}
