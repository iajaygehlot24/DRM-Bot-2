import os
from pyrogram import Client, idle, filters
from aiohttp import web

app = Client(
    "my_bot",
    api_id=os.getenv("10634878"),
    api_hash=os.getenv("2eab99b8459017fff27395cc52f3c860"),
    bot_token=os.getenv("7968712113:AAFxGzK4P8I-CtMgLAjOuSzaNBDpcmHI_pY")
)

print(f"API_ID: {os.getenv('API_ID')}, API_HASH: {os.getenv('API_HASH')}, BOT_TOKEN: {os.getenv('BOT_TOKEN')}")

@app.on_message(filters.command("start"))
async def start(client, message):
    await message.reply("Welcome to DRM-Bot-2!")

@app.on_message(filters.command("pro"))
async def pro(client, message):
    await message.reply("Downloading video...")
    # ... your existing logic for downloading videos ...

async def handle_webhook(request):
    update = await request.json()
    await app.handle_update(update)
    return web.Response(text="OK")

async def start():
    await app.start()
    webhook_url = f"https://{os.getenv('RENDER_EXTERNAL_HOSTNAME')}/webhook"
    await app.set_webhook(webhook_url)
    print(f"Webhook set to: {webhook_url}")

    web_app = web.Application()
    web_app.router.add_post('/webhook', handle_webhook)
    port = int(os.getenv("PORT", 8000))
    runner = web.AppRunner(web_app)
    await runner.setup()
    site = web.TCPSite(runner, "0.0.0.0", port)
    await site.start()
    print(f"Webhook server running on port {port}")

async def stop():
    await app.delete_webhook()
    await app.stop()

if __name__ == "__main__":
    app.run(start())
    idle()
    app.run(stop())
