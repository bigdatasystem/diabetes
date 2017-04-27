var http = require('http');  
const exec = require('child_process').exec;
const spawn = require('child_process').spawn;
var once = 0
    
http.createServer(function(req, res) 
{  
    res.writeHead(200, {
    'Content-Type': 'text/html'
    });

    res.write('<!doctype html>\n<html lang="en">\n' + 
        '\n<meta charset="utf-8">\n<title>Test web page on node.js</title>\n' + 
        '<style type="text/css">* {font-family:arial, sans-serif;}</style>\n' + 
        '\n\n<h3>Processing...</h3>\n' + 
        '\n\n'); 
        
    if (once == 0)
    {
        const bat = spawn('cmd.exe', ['/c', 'train.bat']);

        bat.stdout.on('data', (data) => {
          console.log(data.toString());
        });

        bat.stderr.on('data', (data) => {
          console.log(data.toString());
        });

        bat.on('exit', (code) => {
          console.log(`Child exited with code ${code}`);
        });
        
        //exec('train.bat', (err, stdout, stderr) => {
        //  if (err) {
        //    console.error(err);
        //    return;
        //  }
        //  console.log(stdout);
        //});     
    }
    else
    {
        res.write('<!doctype html>\n<html lang="en">\n' + 
            '\n<meta charset="utf-8">\n<title>Test web page on node.js</title>\n' + 
            '<style type="text/css">* {font-family:arial, sans-serif;}</style>\n' + 
            '\n\n<h3>Done...</h3>\n' + 
            '\n\n');         
    }
    once = 1
    
  res.end();
}).listen(8888, '127.0.0.1');
console.log('Server running at http://127.0.0.1:8888');