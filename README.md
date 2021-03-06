# Extractor

Extractor is a simple, self-hosted web service that extracts content from web pages, Instapaper style. No database, no login system, no bullshit.

All you need to do is send it a URL and a secret code, and it will return the main body of the page, the title, an image, etc. It's particularly good for getting the content of news articles.

The bulk of the work is done by the very cool [node-unfluff](https://github.com/ageitgey/node-unfluff) package.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=http://github.com/claflamme/extractor/tree/master)

## Installation

Clone or download this repository and put it on a server somewhere - you'll need nodejs installed.

Make sure the following environment variables are set:

- `PORT`: The port number that the server should listen on (Heroku sets this automatically).
- `SECRET_KEY`: The secret that must be sent with every request.

Then, run `npm start` from the project root to start the server. All done!

## Usage

Simply make a GET request to `/extract`. The following parameters are required for each request:

- `secret`: The same secret key that you set as an environment variable.
- `url`: The URL of the page you want to extract content from - it's best to URL-encode this string in whatever program you're making the request from.

Example:

```
http://example-site.com/extract?secret=mysecretcode&url=http%3A%2F%2Fgoogle.com
```

Response:

```
{
  "title": "Google",
  "favicon": "/images/branding/product/ico/googleg_lodp.ico",
  "lang": "en",
  "tags": [],
  "image": "/images/branding/googleg/1x/googleg_standard_color_128dp.png",
  "videos": [],
  "text": "A better way to browse the web"
}
```
