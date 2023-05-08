fx_version 'cerulean'
game 'gta5'

description 'ESX Radio'
version '2.0.0'

lua54 'yes'

shared_scripts  {'@es_extended/imports.lua', '@es_extended/locale.lua', 'config.lua'}
server_script 'server.lua'
client_script 'client.lua'

ui_page('html/ui.html')
files {'html/ui.html', 'html/js/script.js', 'html/css/style.css', 'html/img/cursor.png', 'html/img/radio.png'}