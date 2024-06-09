import pathlib 
from django.shortcuts import  render
from django.http import HttpResponse

from visits.models import PageVisit

this_directory = pathlib.Path(__file__).parent.resolve()

def home_page_view(request ):
    queryset = PageVisit.objects.all()
    html_template = 'home.html'  # Check that html_template points to the correct template
    my_context = {
        "page_visit_Count" : queryset.count()
    }  # Add your context data if necessary
    PageVisit.objects.create()
    return render(request, html_template, my_context)


def about_page_view(request):
    my_title = "Hello Abhi"
    html_ = f"""<div>
    <h1>About page</h1>
    <h3>{my_title}</h3>
    <p>This is my About page.</p>
    </div>"""
    html_template = (this_directory / "home.html").read_text()
    
    return HttpResponse(html_)