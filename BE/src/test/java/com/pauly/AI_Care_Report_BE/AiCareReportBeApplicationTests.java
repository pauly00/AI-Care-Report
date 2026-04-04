package com.pauly.AI_Care_Report_BE;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@TestPropertySource(properties = {
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "jwt.secret=testSecretKeyForTestingPurposesOnly1234567890",
        "jwt.expiration=86400000"
})
class AiCareReportBeApplicationTests {

    @Test
    void contextLoads() {
        // Spring 애플리케이션 컨텍스트가 정상적으로 로드되는지 확인
    }
}
