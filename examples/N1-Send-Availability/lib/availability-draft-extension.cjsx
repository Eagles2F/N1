
{DraftStoreExtension} = require 'nylas-exports'
request = require 'request'

class AvailabilityDraftExtension extends DraftStoreExtension

  # When subclassing the DraftStoreExtension, you can add your own custom logic
  # to execute before a draft is sent in the @finalizeSessionBeforeSending
  # method. Here, we're registering the events before we send the draft.
  @finalizeSessionBeforeSending: (session) ->
    body = session.draft().body
    participants = session.draft().participants()
    sender = session.draft().from
    matches = (/data-send-availability="(.*)?" style/).exec body
    if matches?
      json = matches[1].replace(/'/g,'"')
      data = JSON.parse(json)
      data.attendees = []
      data.attendees = participants.map (p) ->
        name: p.name, email: p.email, isSender: c.isMe()
      console.log "Sending request!\n",JSON.stringify data
      serverUrl = "http://localhost:8888/register-events"
      request.post {url: serverUrl, body: JSON.stringify(data)}, (error, resp, data) =>
        console.log(error,resp,data)


module.exports = AvailabilityDraftExtension
