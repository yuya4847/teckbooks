import hello from '../javascripts/hello'
import webpacker from '../javascripts/webpacker'

window.onload = function() {
   document.getElementsByTagName("H1")[0].innerText = hello() + "#" + webpacker();
}
