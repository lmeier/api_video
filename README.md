# ApiVideo

To start the server
```
mix deps.get
mix ecto.create &&& mix ecto.migrate
mix phoenix.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

There are 3 endpoints:

```
POST  /api/videos

GET   /api/videos    

GET   /api/videos/:id  
```

To upload a video, make a POST to api/videos:

``` curl localhost:4000/api/videos \-X POST -H "Content-Type: application/json"  -d '{ "video": {"new_asset_settings": {"playback_policy": "public"}}}' ```

and then from the client make a PUT to the URL that's returned with the video to be uploaded:

```curl -v -X PUT -T myawesomevideo.mp4 "$RETURNED_URL"```


To get my local shell 'client' to work with the Mux/google upload url, I had to include my IP as the cors_origin:

```
$ curl http://checkip.amazonaws.com
69.215.150.193
```

``` 
$ curl localhost:4000/api/videos \-X POST -H "Content-Type: application/json"  -d '{ "video": {"new_asset_settings": {"playback_policy": "public"}, "cors_origin": "69.215.150.1"}}'
```

A GET request to /api/videos returns a list of all uploaded videos:
```curl localhost:4000/api/videos  -X GET ```

A GET to api/videos/VIDEO_ID returns JSON that includes the mux_url
``` curl localhost:4000/api/videos/Q9VEIpQDnyQh2worJsJmvOOimFkb02f2f  -X GET ```

I currently only save a few attributes of a created uploaded on the first client hit. If I were building this for prod, I'd set up a websocket connection with Mux and listen for changes in status of assets. Because I'm not doing this, I'm forced to rely on Mux's db as a source of truth (there are instances where a client could POST to this api for an upload, but then not make the upload, e.g.).   