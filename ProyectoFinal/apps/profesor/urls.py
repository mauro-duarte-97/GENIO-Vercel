from django.urls import path
from apps.profesor.views import ProfesorDetailView, ProfesorListView # Importa las vistas de profesores
from apps.opinion.views import OpinionListView # Importa la vista de opiniones

urlpatterns = [
    path("detalle/<int:pk>", ProfesorDetailView.as_view(), name="detalle_profesor"),
    path("lista/", ProfesorListView.as_view(), name="lista_profesores"),
    # path('institucion/<int:institucion_id>/', ProfesorListView.as_view(), name='profesores_institucion'),
    # path('carrera/<int:carrera_id>/', ProfesorListView.as_view(), name='profesores_carrera'),
    # path('materia/<int:materia_id>/', ProfesorListView.as_view(), name='profesores_materia'),

]