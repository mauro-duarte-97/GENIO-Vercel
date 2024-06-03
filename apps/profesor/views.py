from django.shortcuts import render
from django.views.generic import ListView
from django.views.generic import DetailView
from .models import Profesor
from django.shortcuts import get_object_or_404
from apps.institucion.models import Institucion
from apps.carrera.models import Carrera
from apps.materia.models import Materia


class ProfesorListView(ListView):
    model = Profesor
    template_name = "lista_profesor.html"
    context_object_name = "profesores"

    # Sobreescribimos el método get_queryset para filtrar los profesores por instituto

    def get_queryset(self):
        # Obtiene el ID de la institución desde la URL
        institucion_id = self.kwargs.get('institucion_id')
        carrera_id = self.kwargs.get('carrera_id')
        materia_id = self.kwargs.get('materia_id')

        if institucion_id:
            # Obtiene la instancia de la institución o muestra un error 404 si no se encuentra
            institucion = get_object_or_404(Institucion, id=institucion_id)

            # Filtra los profesores asociados con la institución
            return Profesor.objects.filter(institucion=institucion_id)
        
        elif carrera_id:
            # Obtiene la instancia de la institución o muestra un error 404 si no se encuentra
            carrera = get_object_or_404(Carrera, id=carrera_id)

            # Filtra los profesores asociados con la institución
            return Profesor.objects.filter(carrera=carrera_id)
        
        elif materia_id:
            # Obtiene la instancia de la institución o muestra un error 404 si no se encuentra
            materia = get_object_or_404(Materia, id=materia_id)

            # Filtra los profesores asociados con la institución
            return Profesor.objects.filter(materia_profesor=materia_id)

        else:
            # Si no se proporciona ningún ID de institución, muestra todos los profesores
            return Profesor.objects.all()
        
    # def get_queryset(self):
    #     queryset = Profesor.objects.all()
    #     institucion_id = self.kwargs.get('institucion_id')
    #     carrera_id = self.kwargs.get('carrera_id')
    #     materia_id = self.kwargs.get('materia_id')
        
    #     if institucion_id:
    #         queryset = queryset.filter(institucion_id=institucion_id)
        
    #     if carrera_id:
    #         queryset = queryset.filter(carrera_id=carrera_id)
        
    #     if materia_id:
    #         queryset = queryset.filter(materia_id=materia_id)
        
    #     return queryset





class ProfesorDetailView(DetailView):
    model = Profesor
    template_name = 'detalle_profesor.html'  # Nombre del template
    context_object_name = 'profesor'  # Nombre del objeto en el contexto

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['nombre_institucion'] = self.object.id_institucion.nombre
        return context
