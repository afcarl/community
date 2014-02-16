from django.db import models

# Create your models here.

class WeatherCondition(models.Model):
    name = models.CharField(max_length=20)
