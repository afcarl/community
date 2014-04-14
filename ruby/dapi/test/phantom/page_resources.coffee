
# This script uses phantomjs to invoke the application via HTTP and report
# on both the page and its resources (js, css, images) returned by the page.
#
# Execute from the project root-directory with:
# - phantomjs test/phantom/page_resources.coffee
# - phantomjs test/phantom/page_resources.coffee --render
#
# See the PhantomJS API docs at:
# - http://phantomjs.org/api/
# - http://phantomjs.org/api/webpage/method/open.html

sys  = require('system')
page = require('webpage').create()
fs   = require('fs')

page.viewportSize = { width: 1024, height: 768 }

requests  = []
responses = []
errors    = []
verbose   = false
do_render = false
target_url = "http://www.desk.com" # http://localhost:3000/"
page_title = 'none'
request_count  = 0
received_count = 0

# Process the optional command-line arguments:
for arg, i in sys.args
  if arg.indexOf('--url=') == 0
    tokens = arg.split('=')
    target_url = tokens[1] if tokens.length > 1
  if arg == '--verbose'
    verbose = true
  if arg == '--render'
    do_render = true

req = {}
req.url   = target_url
req.id    = 1
req.epoch = (new Date).getTime()
request_count++
requests.push(req)

page.open target_url, (status) ->
  console.log("page.open -> " + status) if verbose
  if status is "success"
    if do_render
      page.clipRect = { top: 0, left: 0, width: 1024, height: 768 }
      page.render('tmp/page_resources_screenshot.png')
    page_title = page.evaluate ->
      document.title
  else
    pause_before_terminate(1000)

all_resources_received = ->
  request_count * 2 == received_count

pause_before_terminate = (ms) ->
  setTimeout (-> terminate()), ms

terminate = ->
  console.log("terminate") if verbose
  write_json_results_file()
  write_summary_report()
  phantom.exit()

write_json_results_file = ->
  out_obj = {}
  out_obj['page_title'] = page_title
  out_obj['requests']   = requests
  out_obj['responses']  = responses
  out_obj['errors']     = errors
  fs.write('tmp/page_resources_data.json', JSON.stringify(out_obj, null, 2))

write_summary_report = ->
  console.log("summary-report:")
  console.log("  target_url:     " + target_url)
  console.log("  page_title:     " + page_title)
  console.log("  request_count:  " + requests.length)
  console.log("  received_count: " + responses.length)
  console.log("  error count:    " + errors.length)

  for err, i in errors
    console.log("  error " + i + " : " + JSON.stringify(err, null, 2))

  for req, i in requests
    resp_obj1 = response_for(req.id, 'start')
    resp_obj2 = response_for(req.id, 'end')
    elapsed   = resp_obj2.epoch - resp_obj1.epoch
    console.log("  req  id: " + req.id + "  status: " + resp_obj2.status + "  elapsed: " + elapsed  + "  url: " + req.url)

response_for = (id, stage) ->
  for r, i in responses
    return r if (r.id == id) && (r.stage == stage)
  {}

# PhantomJS event handlers follow:

phantom.onError = (msg, trace) ->
  console.log("phantom.onError: " + msg)

page.onInitialized = ->
  console.log("page.onInitialized") if verbose

page.onAlert = ->
  console.log("page.onAlert") if verbose

page.onConfirm = ->
  console.log("page.onConfirm") if verbose

page.onPrompt = ->
  console.log("page.onPrompt") if verbose

page.onLoadStarted = ->
  console.log("page.onLoadStarted") if verbose

page.onLoadFinished = ->
  console.log("page.onLoadFinished") if verbose

page.onResourceRequested = (req) ->
  request_count++
  console.log("page.onResourceRequested " + request_count) if verbose
  req['epoch'] = (new Date).getTime()
  requests.push(req)

page.onResourceReceived = (resp) ->
  received_count++
  console.log("page.onResourceReceived " + received_count) if verbose
  resp['epoch'] = (new Date).getTime()
  responses.push(resp)
  if all_resources_received()
    pause_before_terminate(1000)

page.onResourceError = (err) ->
  console.log "page.onResourceError! " + JSON.stringify(err, null, 2)
  errors.push(err)

page.onUrlChanged = (url) ->
  console.log("page.onUrlChanged: " + url) if verbose
