package com.josur.awsimageupload.datastore;

import com.josur.awsimageupload.profile.UserProfile;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class FakeUserProfileDataStore {

    private static final List<UserProfile> USER_PROFILES = new ArrayList<>();

    static {
        USER_PROFILES.add(new UserProfile(UUID.fromString("f9c16176-d57f-489b-83b2-f029913551a5"), "janetjones", null));
        USER_PROFILES.add(new UserProfile(UUID.fromString("30ebd8a0-574c-4c25-aa20-545be034545b"), "antoniojunior", null));
    }

    public List<UserProfile> getUserProfiles() {
        return USER_PROFILES;
    }
}
