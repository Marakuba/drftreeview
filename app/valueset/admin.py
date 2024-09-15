from django.contrib import admin

from .models import ICD10


@admin.register(ICD10)
class ICD10Admin(admin.ModelAdmin):
    list_display = ["name", "code"]
