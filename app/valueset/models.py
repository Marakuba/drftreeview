from django.db import models


class ICD10(models.Model):
    name = models.CharField("Наименование", max_length=512)
    code = models.CharField("Код", max_length=20)
    description = models.TextField("Дополнительное описание")
    parent = models.ForeignKey(
        "self", null=True, blank=True, related_name="children", on_delete=models.CASCADE
    )

    class Meta:
        verbose_name = "МКБ-10"
        verbose_name_plural = "МКБ-10"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} {self.name}"
