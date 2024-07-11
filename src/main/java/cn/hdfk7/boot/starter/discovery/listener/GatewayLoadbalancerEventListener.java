package cn.hdfk7.boot.starter.discovery.listener;

import com.alibaba.nacos.api.naming.listener.Event;
import com.alibaba.nacos.api.naming.listener.NamingEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.cloud.gateway.event.RefreshRoutesEvent;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.REACTIVE)
@ConditionalOnClass(value = {RefreshRoutesEvent.class})
public class GatewayLoadbalancerEventListener extends AbstractLoadbalancerEventListener {
    @Override
    public void onEvent(Event event) {
        if (event instanceof NamingEvent e) {
            super.onEvent(event);
            applicationEventPublisher.publishEvent(new RefreshRoutesEvent(e));
        }
    }
}
