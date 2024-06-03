from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render
from django.views.generic import TemplateView
from django.views.generic import DetailView
from django.views.generic import ListView
from .models import Alumno

class AlumnoTemplateView(LoginRequiredMixin, TemplateView):
    template_name = "detalle_alumno.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context

class AlumnoDetailView(DetailView):
    model = Alumno
    template_name = 'detalle_alumno.html'  # Nombre del template
    context_object_name = 'alumno'  # Nombre del objeto en el contexto

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context
 
class AlumnoListView(ListView):
    model = Alumno
    template_name = 'lista_alumnos.html'  # Nombre del template a utilizar para mostrar la lista de alumnos
    context_object_name = 'alumnos'  # Nombre del objeto en el contexto
