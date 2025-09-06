## 🔎 ¿Qué es el análisis de Comportamiento de Usuario?
El ámbito que estudia el comportamiento de los usuarios en torno a los anuncios se conoce como análisis del comportamiento del usuario. Dentro del marketing digital, esto se refiere a la recopilación y análisis de datos sobre cómo las personas interactúan con los anuncios en línea.

---

## 🗂️ Proyecto
- Este proyecto es un análisis de publicidades en redes sociales. Se realizó a partir de **bases de datos relacionales** utilizando `SQL`. 

- Los datos se obtuvieron desde [Kaggle](https://www.kaggle.com/datasets/alperenmyung/social-media-advertisement-performance) y se encuentran también en la carpeta [files](/files) en formato .csv. 

- A continuación se presentan los principales hallazgos. El análisis completo, con todas las queries realizadas, está disponible en el archivo [queries](/files/queries.md).

---

### 🗃️ Descripción de los datos
Las 4 bases de datos analizadas son:
- Ads → [ads](/files/datasets/ads.csv)
- Campañas → [campaigns](/files/datasets/campaigns.csv)
- Eventos → [ad_events](/files/datasets/ad_events.csv)
- Usuarios → [users](/files/datasets/users.csv)

Se encuentran relacionadas de la siguiente forma:

<img width="408" height="388" alt="Screenshot 2025-09-05 at 8 57 28 PM" src="https://github.com/user-attachments/assets/0be6d38f-852c-4aca-9681-eb24a5fe3739" />

---

### 📊 Hallazgos
- Cerca de la mitad de los usuarios (40%) son hombres entre 18 y 34 años. Luego se ubican las mujeres en el mismo rango etario, predominando en ambos casos el rango 25-34 años.
- Un tercio de la actividad proviene de Estados Unidos, con Reino Unido en segundo lugar y Canadá en tercero, siendo un público principalmente angloparlante.
- A nivel de interacciones, la mayoría (85%) son impresiones (número de veces que un contenido es mostrado en la pantalla de un usuario), con solo un 0.5% de las interacciones convirtiéndose en compras.
- En términos de horario, no existe un momento del día que genere más interacciones ni compras, distribuyéndose de manera equitativa a través del día. Lo mismo pasa a través de los días de la semana.
- Las campañas más exitosas (en términos de interacciones y compras) no fueron necesariamente las con mayor presupuesto, estando la campaña que generó más compras en n° 13 en términos de presupuesto.
- No existe una plataforma específica que genere mayor conversión, ni tampoco un tipo de publicación en particular (carrusel, stories, post). 


