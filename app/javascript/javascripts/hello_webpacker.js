import hello from '../javascripts/hello'
import webpacker from '../javascripts/webpacker'

$(function(){
   $("H1")[0].innerText =  hello() + "#" + webpacker();
})
