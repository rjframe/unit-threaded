module unit_threaded.uda;

import std.traits;
import std.typetuple;

/**
 * For the given module, return true if this module's member has
 * the given UDA. UDAs can be types or values.
 */
template HasAttribute(alias module_, alias member, alias attribute) if(isSomeString!(typeof(member))) {
    mixin("import " ~ fullyQualifiedName!module_ ~ ";"); //so it's visible
    enum HasAttribute = HasAttributeImpl!(module_, mixin(member), attribute);
}

/**
 * For the given module, return true if this module's member has
 * the given UDA. UDAs can be types or values.
 */
template HasAttribute(alias module_, alias member, alias attribute) if(!isSomeString!(typeof(member))) {
    enum HasAttribute = HasAttributeImpl!(module_, member, attribute);
}

private template HasAttributeImpl(alias module_, alias member, alias attribute) {
    enum isAttribute(alias T) = is(TypeOf!T == attribute);
    alias attrs = Filter!(isAttribute, __traits(getAttributes, member));

    static assert(attrs.length == 0 || attrs.length == 1,
                  text("Maximum number of attributes is 1 for ", attribute));

    static if(attrs.length == 0) {
        enum HasAttributeImpl = false;
    } else {
        enum HasAttributeImpl = true;
    }
}


/**
 * Utility to allow checking UDAs regardless of whether the template
 * parameter is or has a type
 */
private template TypeOf(alias T) {
    static if(__traits(compiles, typeof(T))) {
        alias TypeOf = typeof(T);
    } else {
        alias TypeOf = T;
    }
}



unittest {

    import unit_threaded.attrs;
    import unit_threaded.tests.module_with_attrs;

    //check for value UDAs
    static assert(HasAttribute!(unit_threaded.tests.module_with_attrs, "testAttrs", HiddenTest));
    static assert(HasAttribute!(unit_threaded.tests.module_with_attrs, "testAttrs", ShouldFail));
    static assert(!HasAttribute!(unit_threaded.tests.module_with_attrs, "testAttrs", Name));

    //check for non-value UDAs
    static assert(HasAttribute!(unit_threaded.tests.module_with_attrs, "testAttrs", SingleThreaded));
    static assert(!HasAttribute!(unit_threaded.tests.module_with_attrs, "testAttrs", DontTest));
}
