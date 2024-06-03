from django.shortcuts import render
from django.views.generic import ListView
from django.views.generic import DetailView
from .models import Materia


class MateriaListView(ListView):
    model = Materia
    template_name = "lista_materia.html"
    context_object_name = "materias"

    # Sobreescribimos el método get_queryset para filtrar las materias por carrera
    def get_queryset(self):
        carrera_id = self.kwargs.get('carrera_id')
        if carrera_id:
            return Materia.objects.filter(carrera_id=carrera_id)
        return Materia.objects.all()

class MateriaDetailView(DetailView):
    model = Materia
    template_name = 'detalle_materia.html'  # Nombre del template
    context_object_name = 'materia'  # Nombre del objeto en el contexto

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['titulo_carrera'] = self.object.fk_id_carrera.titulo
        return context
