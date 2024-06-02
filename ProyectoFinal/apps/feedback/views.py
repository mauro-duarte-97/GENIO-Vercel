from django.shortcuts import render
from django.urls import reverse_lazy
from django.contrib import messages
from django.views.generic import FormView
from .forms import FeedbackForm
from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.mail import EmailMessage

# class FeedbackView(LoginRequiredMixin, FormView):
#     template_name = 'feedback_box.html'
#     form_class = FeedbackForm
#     success_url = reverse_lazy('user_home')  # Redirige aquí después de enviar el formulario correctamente

#     def form_valid(self, form):
#         feedback = form.save(commit=False)
#         feedback.user = self.request.user  # Asocia el usuario autenticado con el feedback
#         feedback.save()
        
#         # Crear el cuerpo del correo en formato texto plano
#         text_content = f"""
#         El usuario {feedback.user.nombre} de email {feedback.user.email} ha enviado un nuevo feedback:

#         {feedback.mensaje}
#         """
#         email = EmailMessage(
#             subject=f'Nuevo feedback - {feedback.titulo}',
#             body= text_content,
#             to=['m.e.b.d.0904@ifts18.edu.ar'],)  # Cambiar por tu dirección de correo electrónico
#         try:
#             # Enviar correo electrónico
#             email.send()
#             messages.success(self.request, 'Gracias por tu feedback! Trabajaré en ello lo antes posible')

#         except Exception as e:
#             messages.error(self.request, 'No se pudo enviar el feedback')

#         return super().form_valid(form)

#     def get_form_kwargs(self):
#         kwargs = super(FeedbackView, self).get_form_kwargs()
#         kwargs['user'] = self.request.user  # Añade el usuario actual a los kwargs del formulario
#         return kwargs




from django.core.mail import EmailMessage
from django.contrib import messages
from django.views.generic.edit import FormView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse_lazy
from django.utils import timezone
from .models import Feedback, EmailLog
from .forms import FeedbackForm
from datetime import timedelta

class FeedbackView(LoginRequiredMixin, FormView):
    template_name = 'feedback_box.html'
    form_class = FeedbackForm
    success_url = reverse_lazy('user_home')  # Redirige aquí después de enviar el formulario correctamente

    def form_valid(self, form):
        feedback = form.save(commit=False)
        feedback.user = self.request.user  # Asocia el usuario autenticado con el feedback
        
        # Verificar si el usuario puede enviar otro correo hoy
        if not can_send_email(feedback.user):
            messages.error(self.request, 'Has alcanzado el límite diario de envíos de correos.')
            return self.form_invalid(form)
        
        feedback.save()

        # Crear el cuerpo del correo en formato texto plano
        text_content = f"""
        El usuario {feedback.user.nombre} de email {feedback.user.email} ha enviado un nuevo feedback:

        {feedback.mensaje}
        """
        email = EmailMessage(
            subject=f'Nuevo feedback - {feedback.titulo}',
            body=text_content,
            to=['m.e.b.d.0904@ifts18.edu.ar'],  # Cambiar por tu dirección de correo electrónico
        )
        try:
            # Enviar correo electrónico
            email.send()
            # Registrar el envío del correo
            register_email(feedback.user)
            messages.success(self.request, 'Gracias por tu feedback! Trabajaré en ello lo antes posible')
        except Exception as e:
            messages.error(self.request, 'No se pudo enviar el feedback')

        return super().form_valid(form)

    def get_form_kwargs(self):
        kwargs = super(FeedbackView, self).get_form_kwargs()
        kwargs['user'] = self.request.user  # Añade el usuario actual a los kwargs del formulario
        return kwargs

def can_send_email(user):
    # Obtener el inicio del día actual
    start_of_day = timezone.now().replace(hour=0, minute=0, second=0, microsecond=0)
    # Contar los correos enviados por el usuario en el día actual
    email_count = EmailLog.objects.filter(user=user, timestamp__gte=start_of_day).count()
    return email_count < 2

def register_email(user):
        EmailLog.objects.create(user=user)
