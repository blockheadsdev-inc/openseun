package io.seun.seunswap.configuration;


import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenAPIConfiguration {

    @Bean
    public OpenAPI customOpenAPI(){
        return new OpenAPI()
                .info(
                        new Info()
                                .title("SEUNSwap API Documentation")
                                .version("v3")
                                .description("SEUNswap is an open source project, implementing an automated exchange for Hedera-based fungible tokens. It currently allows users to list these tokens and provide their prices.")
                                .license(
                                        new License()
                                                .name("GNU General Public License")
                                                .url("https://www.gnu.org/licenses/gpl-3.0.html")));
    }

}
