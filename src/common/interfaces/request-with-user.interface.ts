import type { Request } from 'express';
import type { AuthenticatedUser } from '../interfaces/authenticated-user.interface';

/** طلب Express موسّع بحقل user الذي يحقنه JwtAuthGuard */
export type RequestWithUser = Request & { user?: AuthenticatedUser };
