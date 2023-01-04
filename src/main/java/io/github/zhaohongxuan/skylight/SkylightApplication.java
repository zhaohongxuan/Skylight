package io.github.zhaohongxuan.skylight;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class SkylightApplication {

    public static void main(String[] args) {
        SpringApplication.run(SkylightApplication.class, args);
    }

    @GetMapping("/hello")
    public String hello(){
        return "Hello World";
    }

}
