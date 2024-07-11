package cn.hdfk7.boot.starter.discovery.listener;

import com.alibaba.nacos.api.naming.listener.Event;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.SERVLET)
public class LoadbalancerEventListener extends AbstractLoadbalancerEventListener {

    @Override
    public void onEvent(Event event) {
        super.onEvent(event);
    }
}
