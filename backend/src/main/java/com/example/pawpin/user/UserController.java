//package com.example.pawpin.user;
//
//import java.util.List;
//
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//@RestController
//@RequestMapping("/users")
//public class UserController {
//
//    private final UserRepository repository;
//
//    public UserController(UserRepository repository) {
//        this.repository = repository;
//    }
//
//    @GetMapping
//    public List<User> allUsers() {
//        return repository.findAll();
//    }
//}
