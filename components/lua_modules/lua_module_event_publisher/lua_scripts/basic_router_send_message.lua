local event_publisher = require("event_publisher")

local a = type(args) == "table" and args or {}

local channel = a.channel
local chat_id = a.chat_id
local message_text = a.message_text or a.text or "hello from lua event_router"

local function require_string(name, value)
    if type(value) ~= "string" or value == "" then
        error("missing args." .. name)
    end
end

require_string("channel", channel)
require_string("chat_id", chat_id)

print(string.format(
    "[event_router_demo] publish trigger event_key=%s channel=%s chat_id=%s",
    "lua_im_send_message",
    channel,
    chat_id
))

event_publisher.publish({
    source_cap = "lua_script",
    event_type = "trigger",
    source_channel = channel,
    target_channel = channel,
    chat_id = chat_id,
    content_type = "trigger",
    message_id = "lua_im_send_message",
    correlation_id = "lua_im_send_message",
    text = message_text,
    session_policy = "trigger",
    payload = {
        channel = channel,
        chat_id = chat_id,
        text = message_text,
    },
})

print("[event_router_demo] send message trigger published")
