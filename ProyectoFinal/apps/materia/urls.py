from django.urls import path
from apps.materia.views import MateriaDetailView, MateriaListView # Importa las vistas de materias
from apps.profesor.views import ProfesorListView # Importa la vista de profesores

urlpatterns = [
    path("detalle/<int:pk>", MateriaDetailView.as_view(), name="detalle_materia"),
    path("lista/", MateriaListView.as_view(), name="lista_materias"),
    path('<int:materia_id>/profesores/', ProfesorListView.as_view(), name='profesores_materia'),
]