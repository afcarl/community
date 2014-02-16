from django.contrib import admin

# Register your models here.

from weather.models import WeatherCondition

admin.site.register(WeatherCondition)
