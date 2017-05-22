#!/usr/bin/env python

import httplib2
import base64

URL = 'http://pacs.idoimaging.com:8042/patients'
h = httplib2.Http()
headers = { 'content-type' : 'application/dicom' }
headers['authorization'] = 'Basic ' + base64.b64encode('demo:demo')
resp, content = h.request(URL, 'GET', headers = headers)
if resp.status == 200:
    print(content)
else:
    print("Oh noes!")
