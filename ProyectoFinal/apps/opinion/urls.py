# urls.py
from django.urls import path
from .views import OpinionListView

urlpatterns = [
    path('<str:model_name>/<int:entity_id>/', OpinionListView.as_view(), name='opiniones_por_entidad'),
]
