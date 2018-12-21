# Web Scraping con R y Fernández-Villaverde

La razón principal por la que leía el blog de Economía en español [Nada es gratis](http://nadaesgratis.es/author/villaverde) eran los posts de Jesús Fernandez Villaverde (en adelante, JFV). JFV es un economista macro de primera línea con unas habilidades técnicas envidiables, además de un conocimiento de historia económica profundo y atento también a la evolución del mundo no-occidental. 

Más allá de su producción académica, JFV ha participado en la "discusión" pública de muchas formas diferentes, desde el muy recomendable espacio de comentarios en sus entradas, a las [conferencias](https://www.youtube.com/results?search_query=fernandez+villaverde+rafael+del+pino) en la Fundación Rafael del Pino, sus [artículos](https://elpais.com/autor/jesus_fernandez_villaverde/a) en El País o, incluso, sus apariciones en el Congreso de los Diputados en las que ha recordado más de una [verdad incómoda](http://nadaesgratis.es/fernandez-villaverde/comparecencia-en-el-congreso-comision-de-investigacion-sobre-la-crisis-financiera-de-espana) a los miembros del establishment político.

En Nada es gratis, sus [entradas](http://nadaesgratis.es/author/villaverde) trataban sobre política económica, diseño institucional o métodos cuantitativos de un modo en el que planteaba cuestiones difíciles de una forma realmente didáctica. Tras un tiempo sin escribir nuevas entradas en el blog (está cerca de publicar tres libros diferentes), [ha dejado de ser miembro](https://twitter.com/cultrun/status/1041715468992692224) la fundación Nada es Gratis debido a su desacuerdo con un cuestionable posicionamiento público de los editores del blog que no me interesa enlazar aquí.

Hacía tiempo que buscaba en el archivo del blog para leer entradas antiguas de su autoría. Sin embargo, la página de las entradas de cada autor las muestra en series de 30 (con una miniatura por cada entrada) lo que convierte el proceso en algo bastante lento y aburrido. 

Si tuviese una lista con los títulos, las fechas y los enlaces de la entrada podría acceder de forma más sencilla a estas. Es por ello que, para mi propio beneficio, y en honor a los [fans de JFV](https://twitter.com/SFLMadrid/status/857970452723109888), he utilizado algunos paquetes de R para extraer esta información y crear una base de datos útil.

En este documento describiré el procedimiento que he seguido.

## Procedimiento 

La página está diseñada de modo que no puedo extraer los enlaces directamente desde la [url](http://nadaesgratis.es/author/villaverde). Por ello, la he descargado tras dar los clics pertinentes para llegar a su primera entrada en 2009. 

Una vez descargada puedo cargarla mediante `choose.files`.

```r
# Instalar y cargar los paquetes necesarios
install.packages("tidyverse")
install.packages("rvest")

library("rvest")
library("tidyverse")

web <- choose.files()

page <- read_html(web)
```

Para seleccionar el contenido que me interesa, utilizo la extensión Chrome Selector Gadget (en Chrome).

![jfv-selector](/img/jfv-selector.png)

Al seleccionar la parte de la web de la que voy a extraer los datos, obtengo un selector CSS que identifica su contenido. En el caso de los títulos es `h3 a`.

```r
# Extraer títulos y enlaces

titles_html <- html_nodes(page,'h3 a')

## Separar texto

titles <- html_text(titles_html)
```

Para los enlaces, busco el atributo que los identifica en el objeto `titles_html` y después creo el vector correspondiente, que tengo que limpiar también.

Por alguna razón que desconozco, el último elemento extraído conduce a una web de mudanzas turca (sí, una web de mudanzas turca). Puesto que no me interesa, la elimino en ambos vectores.

```r
### Limpiar el vector

titles <- titles[-c(617)]

## Separar los enlaces

urls <- titles_html %>%
  xml_attr('href')

### Limpiar el vector

urls <- urls[-c(617)]

# Extraer las fechas

dates_html <- html_nodes(page, 'time')

## Separar el texto

dates <- html_text(dates_html)
```

Las fechas contienen algunos caracteres extra que me interesan. Para eliminarlos, utilizo gsub. Finalmente, uno los vectores en un data.frame y guardo el resultado.

```r
### Limpiar el vector

dates <- gsub("\n\t\t\t\t\t\t","", dates)
dates <- gsub("\t\t\t\t\t","", dates)

# Crear un data.frame

JFV <- data.frame(dates, titles, urls)

# Guardar el resultado

write.csv2(JFV, file = "JFV.csv", row.names=FALSE)
```

En este [repositorio](https://github.com/wronglib/web-scraping-r-jfv) en Github incluyo todos los elementos necesarios para replicar el resultado (la web y el script de R), así como el propio resultado.
