import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;

public class LoginTest {

    public static void main(String[] args) {
        // Set the path to the ChromeDriver executable
        System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");

        // Create a new instance of the ChromeDriver
        WebDriver driver = new ChromeDriver();

        // Maximize the browser window
        driver.manage().window().maximize();

        // Navigate to the login page
        driver.get("https://sasor-wbs.webflow.io/user-pages/log-in");

        // Find the username and password input fields
        WebElement usernameInput = driver.findElement(By.id("username"));
        WebElement passwordInput = driver.findElement(By.id("password"));

        // Enter the credentials
        usernameInput.sendKeys("your_username");
        passwordInput.sendKeys("your_password");

        // Find and click the login button
        WebElement loginButton = driver.findElement(By.id("loginButton"));
        loginButton.click();

        // Wait for the next page to load (you may need to use an explicit wait)

        // Perform assertions or validations on the logged-in state

        // Close the browser
        driver.quit();
    }
}
