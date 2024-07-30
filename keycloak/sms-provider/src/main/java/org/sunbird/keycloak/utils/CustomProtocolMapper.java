package org.sunbird.keycloak.utils;

//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.keycloak.models.ProtocolMapperModel;
import org.keycloak.models.UserModel;
import org.keycloak.models.UserSessionModel;
import org.keycloak.protocol.oidc.mappers.*;
import org.keycloak.provider.ProviderConfigProperty;
import org.keycloak.representations.IDToken;

public class CustomProtocolMapper extends AbstractOIDCProtocolMapper implements OIDCAccessTokenMapper, OIDCIDTokenMapper, UserInfoTokenMapper {
    private static final List<ProviderConfigProperty> configProperties = new ArrayList();
    public static final String PROVIDER_ID = "customer-sai-mapper";

    public CustomProtocolMapper() {
    }

    public List<ProviderConfigProperty> getConfigProperties() {
        return configProperties;
    }

    public String getId() {
        return "customer-sai-mapper";
    }

    public String getDisplayType() {
        return "customer-sai-mapper";
    }

    public String getDisplayCategory() {
        return "customer-sai-mapper";
    }

    public String getHelpText() {
        return "customer-sai-mapper";
    }

    protected void setClaim(IDToken token, ProtocolMapperModel mappingModel, UserSessionModel userSession) {
        UserModel user = userSession.getUser();
        token.getOtherClaims().put("org", user.getAttributes().get("org"));
        token.getOtherClaims().put("roles", user.getAttribute("roles"));
    }

    public static ProtocolMapperModel create(String name, boolean accessToken, boolean idToken, boolean userInfo) {
        ProtocolMapperModel mapper = new ProtocolMapperModel();
        mapper.setName(name);
        mapper.setProtocolMapper("customer-sai-mapper");
        mapper.setProtocol("openid-connect");
        Map<String, String> config = new HashMap();
        if (accessToken) {
            config.put("access.token.claim", "true");
        }

        if (idToken) {
            config.put("id.token.claim", "true");
        }

        if (userInfo) {
            config.put("userinfo.token.claim", "true");
        }

        mapper.setConfig(config);
        return mapper;
    }

    static {
        OIDCAttributeMapperHelper.addIncludeInTokensConfig(configProperties, org.sunbird.keycloak.utils.CustomProtocolMapper.class);
    }
}
