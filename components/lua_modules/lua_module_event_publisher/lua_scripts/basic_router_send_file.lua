local event_publisher = require("event_publisher")
local storage = require("storage")

local a = type(args) == "table" and args or {}

local channel = a.channel
local chat_id = a.chat_id
local file_caption = a.file_caption or a.caption or "lua trigger demo file"
local root_dir = storage.get_root_dir()
local demo_dir = storage.join_path(root_dir, "demo")
local demo_file_path = a.file_path or storage.join_path(demo_dir, "lua_event_router_demo.txt")

local function require_string(name, value)
    if type(value) ~= "string" or value == "" then
        error("missing args." .. name)
    end
end

local function file_event_key_for_channel(name)
    if name == "qq" then
        return "lua_qq_send_file"
    end
    if name == "telegram" then
        return "lua_tg_send_file"
    end
    if name == "feishu" then
        return "lua_feishu_send_file"
    end
    error("file send only supports qq / telegram / feishu, got channel=" .. tostring(name))
end

require_string("channel", channel)
require_string("chat_id", chat_id)

storage.mkdir(demo_dir)
storage.write_file(demo_file_path, table.concat({
    "lua event router demo",
    "channel=" .. channel,
    "chat_id=" .. chat_id,
    "caption=" .. file_caption,
}, "\n") .. "\n")

local event_key = file_event_key_for_channel(channel)

print(string.format(
    "[event_router_demo] publish trigger event_key=%s channel=%s chat_id=%s path=%s",
    event_key,
    channel,
    chat_id,
    demo_file_path
))

event_publisher.publish({
    source_cap = "lua_script",
    event_type = "trigger",
    source_channel = channel,
    target_channel = channel,
    chat_id = chat_id,
    content_type = "trigger",
    message_id = event_key,
    correlation_id = event_key,
    text = file_caption,
    session_policy = "trigger",
    payload = {
        channel = channel,
        chat_id = chat_id,
        path = demo_file_path,
        caption = file_caption,
    },
})

print("[event_router_demo] send file trigger published path=" .. demo_file_path)
