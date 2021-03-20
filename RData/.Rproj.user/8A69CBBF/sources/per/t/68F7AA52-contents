selfsum<-function(x, y){
  z<-x+y
  return(z)
}

selfdate<-function(type="short"){
  switch (type,
    long = format(Sys.time(),"%A %B %d %Y"),
    short = format(Sys.time(),"%m-%d-%y"),
    cat(type,"can't be recognized")
  )
}

selfsum(2,3)
selfdate("long")
selfdate("short")
selfdate()
selfdate("mid")
