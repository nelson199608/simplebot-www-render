from urllib.parse import quote_plus

import simplebot
from deltachat import Message
from simplebot.bot import DeltaBot, Replies
from simplebot_instantview import prepare_html, session  # noqa


@simplebot.command()
def wiki(bot: DeltaBot, payload: str, message: Message, replies: Replies) -> None:
    """Send me any text in private to search in the web."""
    if not replies.has_replies() and not message.chat.is_multiuser() and message.text:
        text, html = _search(bot.self_contact.addr, message.text)
        replies.add(text=text or "Search results", html=html, quote=message)


def _search2_cmd(1, bot, payload, message, replies) -> tuple:
    with session.get(f"https://es.m.wikipedia.org/wiki/{quote_plus(query)}") as resp:
        resp.raise_for_status()
        return prepare_html(bot_addr, resp.url, resp.text)
