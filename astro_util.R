

parsec_to_ly= function(value){
  return(value*3.26156)
}

#Habital Zone in AU
#Taken from https://www.astronomynotes.com/lifezone/s2.htm
min_habitable_zone_boundary = function(star_luminosity){
  star_boundary = 0.9*sqrt((star_luminosity/1))
  return(star_boundary)
}

max_habitable_zone_boundary = function(star_luminosity){
  star_boundary = 1.5*sqrt((star_luminosity/1))
  return(star_boundary)
}