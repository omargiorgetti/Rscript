# rotation of the word "Animation"
# in a loop; change the angle and color
# step by step
for (i in 1:360) {
	# redraw the plot again and again
	plot(1,ann=FALSE,type="n",axes=FALSE)
	# rotate; use rainbow() colors
	text(1,1,"Animation",srt=i,col=rainbow(360)[i],cex=7*i/360)
	# pause for a while
#	Sys.sleep(0.01)
}