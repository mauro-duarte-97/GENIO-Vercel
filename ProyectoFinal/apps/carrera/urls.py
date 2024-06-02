from django.urls import path
from apps.carrera.views import CarreraDetailView, CarreraListView # Importa las vistas de carreras
from apps.opinion.views import OpinionListView # Importa la vista de opiniones
from apps.profesor.views import ProfesorListView # Importa la vista de profesores
from apps.materia.views import MateriaListView # Importa la vista de materias

urlpatterns = [
    path("detalle/<int:pk>", CarreraDetailView.as_view(), name="detalle_carrera"),
    path("lista/", CarreraListView.as_view(), name="lista_carreras"),
    path('<int:carrera_id>/materias/', MateriaListView.as_view(), name='lista_materias_carrera'),
    path('<int:carrera_id>/profesores/', ProfesorListView.as_view(), name='lista_profesores_carrera'),
]