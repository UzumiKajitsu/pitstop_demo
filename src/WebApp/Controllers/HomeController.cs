namespace PitStop.Controllers;

public class HomeController : Controller
{
    [HttpGet]
    [HttpHead]
    public IActionResult Index()
    {
        return View();
    }

    [HttpGet]
    [HttpHead]
    public IActionResult About()
    {
        return View();
    }

    [HttpGet]
    [HttpHead]
    public IActionResult Error()
    {
        return View();
    }
}