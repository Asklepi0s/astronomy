library(data.table)
library(stringr)
source('~/astronomy/astro_util.R')



### EXTRACT ###

data_file_name = '~/astronomy/data/hygdata_v3.csv'
source_file_name = 'https://raw.githubusercontent.com/astronexus/HYG-Database/master/hygdata_v3.csv'

if(file.exists(data_file_name)){
  df = fread(data_file_name) 
} else{
  df = fread(source_file_name)
  fwrite(df,data_file_name)
}



### TRANSFORM ###


# Distances
df[,dist_ly := lapply(dist,parsec_to_ly)] #Add lightyears


## Spectral Classification

#Overrides
df[spect == '(G3w)F7', spect := 'G3w/F7']

#Unknown and Spectral Peculiarities
df[spect =='',spectral_harvard := 'Unknown']
df[spect =='a',spectral_harvard := 'Spectral Peculiarity']
df[spect %like% '^f',spectral_harvard := 'Spectral Peculiarity']
df[spect %like% '^g',spectral_harvard := 'Spectral Peculiarity']
df[spect %like% '^k',spectral_harvard := 'Spectral Peculiarity']
df[spect %like% '^m',spectral_harvard := 'Spectral Peculiarity']
df[spect %like% '^p',spectral_harvard := 'Spectral Peculiarity']

# Mount Wilson classification
df[!spectral_harvard %in% c('Unknown','Spectral Peculiarity'),spectral_mk := gsub('(^[a-z]*)(.*)','\\1',spect)]
df[is.na(spectral_mk) == TRUE,spectral_mk := '']

# Create intermediary. Delete at end
df[!spectral_harvard %in% c('Unknown','Spectral Peculiarity'),spectral_harvard := gsub('(^[a-z]*)(.*)','\\2',spect)]

# Split off tail
df[!spectral_harvard %in% c('Unknown','Spectral Peculiarity'),spectral_temperature := gsub('(^.)(.*)','\\2',spectral_harvard)]
df[!spectral_harvard %in% c('Unknown','Spectral Peculiarity'),spectral_harvard := gsub('(^.)(.*)','\\1',spectral_harvard)]
#View(df[!spectral_harvard %in% c('Unknown','Spectral Peculiarity') & !spectral_temperature %like% '^[0-9]'])
df[!spectral_harvard %in% c('Unknown','Spectral Peculiarity'),spectral_tail := gsub('(^[0-9]*)(.*)','\\2',spectral_temperature)]
df[!spectral_harvard %in% c('Unknown','Spec1tral Peculiarity'),spectral_temperature := gsub('(^[0-9]*)(.*)','\\1',spectral_temperature)]



### Load ###

fwrite(df,'~/astronomy/data/hygdata_etl_output.csv',sep = ',')
