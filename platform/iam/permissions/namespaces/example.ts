import { Namespace, Context } from "@ory/keto-namespace-types"

class User implements Namespace {}

class Document implements Namespace {
    related: {
        editors: User[]
        viewers: User[]
    }

    permits = {
        write: (ctx: Context): boolean =>
            this.related.editors.includes(ctx.subject),
        read: (ctx: Context): boolean =>
            this.permits.write(ctx) || this.related.viewers.includes(ctx.subject),
    }
}