//'use strict'
//
// Mini webserver for testing NanoUI templates
//
const fs = require('fs');
const http = require('http');
const mime = require('mime');
const path = require('path');
const url = require('url');
const dot = require('dot');

// Configuration constants
var config = { 
  "port": 8000,         // Port to listen on
  "dir": "../../nano",  // Path to SS13 nano folder
};

// Choose your templates here.  Hint: You'll probably never change layout, main is the one you want.
var templateData = {
  layout: "layout_default.tmpl",
  main: "smes.tmpl"
};

// In BYOND everything is sent to the client's byond cache, so its all in one flat directory.
// On the actual filesystem here of course, its in subfolders.  To emulate that we decide what
// folder to look in based on file extention.
const extFolderMapping = {
  ".png": path.join(process.cwd(), config.dir, "images"),
  ".jpg": path.join(process.cwd(), config.dir, "images"),
  ".jpeg": path.join(process.cwd(), config.dir, "images"),
  ".gif": path.join(process.cwd(), config.dir, "images"),
  ".js": path.join(process.cwd(), config.dir, "js"),
  ".css": path.join(process.cwd(), config.dir, "css"),  
  ".tmpl": path.join(process.cwd(), config.dir, "templates")
};

// Read the shipped index.html as a doT template.
var genIndexHtml = dot.template(fs.readFileSync('index.html', 'utf8'));

// the main thing
var server = http.createServer( function(request, response) {

  // extract the pathname from the request URL  
  var pathname = url.parse(request.url).pathname;
  
  // Exception for front page
  if (pathname === '/') {
    let initialData = JSON.parse(fs.readFileSync('initialData.json', 'utf8'));
    response.writeHead(200, {"Content-Type": "text/html"});
    response.write(genIndexHtml({
      initialDataJson: JSON.stringify(initialData),
      templateDataJson: JSON.stringify(templateData)
    }));
    response.end();
    return;
  }

  // Map URL path to physical path.
  // First check our folder mapping
  var filename;
  var fileExt = path.extname(pathname);
  if (fileExt in extFolderMapping) {
    filename = path.join(extFolderMapping[fileExt], path.basename(pathname));
  } else {
    // Otherwise fall back to just a relative path to our base dir.
    filename = path.join(process.cwd(), config.dir, pathname);
  }

  // console.log("Trying to serve ", pathname, " from ", filename);

  // Does this path exist?  
  fs.exists(filename, function(gotPath) {
    // no, bail out    
    if (!gotPath) {
      console.warn("Path: %s File: %s NOT FOUND", pathname, filename);
      response.writeHead(404, {"Content-Type": "text/plain"});
      response.write("404 Not Found");
      response.end();
      return;
    }

    // still here? filename is good    
    // look up the mime type by file extension
    response.writeHead(200, {'Content-Type': mime.getType(filename)});
    
    // read and pass the file as a stream. Not really sure if this is better,
    // but it feels less block-ish than reading the whole file
    // and we get to do awesome things with listeners
    fs.createReadStream(filename, {
      'flags': 'r',
      'encoding': 'binary',
      'mode': 0x3146,  // 0666
      'bufferSize': 4 * 1024
    }).addListener( "data", function(chunk) {
      response.write(chunk, 'binary');
    }).addListener( "close",function() {
      response.end();
    });
    
  }); 
});

// fire it up
server.listen(config.port);
console.log("Listening on port %d", config.port);
