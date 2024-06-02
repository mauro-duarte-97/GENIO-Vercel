from django.urls import path
from .views import AlumnoDetailView
from .views import AlumnoListView

urlpatterns = [
    path('detalle/<int:pk>', AlumnoDetailView.as_view(), name='alumno_detalle'),
    path('lista/', AlumnoListView.as_view(), name='alumno_list'),
]

    