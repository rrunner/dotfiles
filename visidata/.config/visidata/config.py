options.motd_url = ""
options.default_width = 20
options.encoding = "utf-8"

# ctrl-d to scroll down half-page
Sheet.addCommand(
    None,
    "scroll-halfpage-down",
    "cursorDown(nScreenRows//2); sheet.topRowIndex += nScreenRows//2",
    "scroll half page forward (like Vim Ctrl-D)",
)
BaseSheet.bindkey("^D", "scroll-halfpage-down")

# ctrl-u to scroll up half-page
Sheet.addCommand(
    None,
    "scroll-halfpage-up",
    "cursorDown(-nScreenRows//2); sheet.bottomRowIndex -= nScreenRows//2",
    "scroll half page backward (like Vim Ctrl-U)",
)
BaseSheet.bindkey("^U", "scroll-halfpage-up")

# unbind original keymaps
BaseSheet.unbindkey("^F")
BaseSheet.unbindkey("^B")
