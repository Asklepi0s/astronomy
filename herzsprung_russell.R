#Herzprung-Russell Diagram

df = fread('~/astronomy/data/hygdata_etl_output.csv')

plot_data = df[(dist_ly < 1000) & ci < 2 & spectral_harvard %in% c('O','A','B','D','F','G','K','M')]

plot_label = plot_data[proper %in% c('Proxima Centauri','Aldebaran',
                                     'Sol','Vega','Betelgeuse','Polaris',
                                     'Formalhaut','Procyon','Rigel')]

plot = ggplot(plot_data, aes(ci,log(lum),color = spectral_harvard)) + 
  geom_point(alpha = 0.3) + 
  geom_label(data=plot_label, aes(label=proper), label.size = 0.35, color = "black")

plot + scale_color_manual("Harvard Classification",
                          values=c("lightblue","blue","dodgerblue1","#ccffff","yellow","orange","red","darkblue")) + 
  labs(title = 'Herzsprung-Russell', 
       subtitle = 'Main sequence stars within 1000 ly from sun',
       caption = 'Hyg-Database https://github.com/astronexus/HYG-Database',
       x = 'Color (B-V)', y='Luminosity(Sun = 1)')
