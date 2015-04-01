w <- gwindow("simple web app")
b <- gbutton("click me", cont=w)
addHandlerClicked(b, handler=function(h,...) {
 galert("Ouch, that hurt", parent=w)
})