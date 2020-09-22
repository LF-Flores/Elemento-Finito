# Elemento-Finito
Implementaciones en el lenguaje Julia de los algoritmos vistos en el curso MM-516, Elemento finito, III-Periodo académico 2020. Pretende ilustrar a los estudiantes un lenguaje alternativo a Matlab/Octave que originalmente se utiliza en el curso.

# Descarga
Para quienes quieran tener una copia local de este repositorio que se pueda actualizar fácilmente deben seguir las siguientes instrucciones:

## Windows
Si no lo tienen ya, descarguen git para windows en: https://gitforwindows.org/ y desde la terminal de git utilicen el comando
```
git clone https://github.com/LF-Flores/Elemento-Finito.git nombre_de_carpeta_local
```
donde `nombre_de_carpeta_local` es el nombre de la carpeta donde quieren tener la copia local de este repositorio.

## Linux/macOS
Ya tienen git instalados en su computadora, así que utilizan el comando antes mencionado:
```
git clone https://github.com/LF-Flores/Elemento-Finito.git nombre_de_carpeta_local
```
donde `nombre_de_carpeta_local` es el nombre de la carpeta donde quieren tener la copia local de este repositorio.

## Actualización
Cuando deseen actualizar los contenidos de la carpeta, solo deben usar el siguiente comando de git en la carpeta donde clonaron:
```
git pull origin master
```

# Descripción de contenidos
La carpeta llamada **static_notebooks** contiene archivos de extensión `.html` que podrán visualizar en su navegador con ejecutarlos (doble click) y ver el código del lenguaje Julia junto con los resultados ue produce y una descripción de lo que se hizo. Como alternativa para visualizar los cuadernos sin descargarlos, es posible colocar el URL del archivo dentro de github en la siguiente página: https://htmlpreview.github.io/ 

La carpeta **scripts** contiene los archivos con extensión `.jl` ejecutables por el lenguaje Julia para que puedan experimentar con ellos ya sea con Julia directamente o con el paquete [Pluto.jl](https://github.com/fonsp/Pluto.jl) que se utilizó para crear estos scripts.

# Instalación del lenguaje Julia
La documentación de Julia es muy buena para explicar el proceso de instalación, no obstante, si desean una instalación realmente rápida, pueden utilizar el método propuesto el usuario abelsiqueira en su repositorio [jill](https://github.com/abelsiqueira/jill). Pueden acceder al link para más información, pero basta en Linux/macOS con utilizar el comando:
```
bash -ci "$(curl -fsSL https://raw.githubusercontent.com/abelsiqueira/jill/master/jill.sh)"
```
En windows, deben pasar por el proceso completo de instalación propuesto en [la página oficial del lenguaje Julia](https://julialang.org/downloads/).

# Instalación de Pluto.jl
Una vez instalado Julia, deberían poder comenzar un proceso de Julia desde la terminal con la palabra `julia` y allí presionar la tecla `]` para comenzar el REPL (read–eval–print loop) del administrador de paquetes de Julia. Allí, basta con escribir `add Pluto` (note la mayúscula en `Pluto`) para que comience a descargarlo. De la misma manera se pueden instalar cualquier otro paquete que guste y puedan requerir los scripts.
